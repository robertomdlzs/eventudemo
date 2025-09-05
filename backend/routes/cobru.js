const express = require('express');
const router = express.Router();
const CobruService = require('../services/cobruService');

const cobruService = new CobruService();

/**
 * GET /api/payments/cobru/config
 * Obtener configuración de Cobru
 */
router.get('/config', (req, res) => {
  try {
    const config = cobruService.getConfig();
    res.json({
      success: true,
      data: config
    });
  } catch (error) {
    console.error('Error obteniendo configuración Cobru:', error);
    res.status(500).json({
      success: false,
      error: 'Error obteniendo configuración de Cobru'
    });
  }
});

/**
 * POST /api/payments/cobru/create
 * Crear transacción de pago con Cobru
 */
router.post('/create', async (req, res) => {
  try {
    const {
      amount,
      currency = 'COP',
      description,
      reference,
      customerEmail,
      customerName,
      customerPhone,
      eventId,
      ticketTypeId,
      quantity
    } = req.body;

    // Validar datos requeridos
    if (!amount || !description || !reference) {
      return res.status(400).json({
        success: false,
        error: 'Faltan datos requeridos: amount, description, reference'
      });
    }

    // Construir URLs de retorno
    const baseUrl = process.env.FRONTEND_URL || 'http://localhost:3000';
    const returnUrl = `${baseUrl}/checkout/success?payment=cobru&reference=${reference}`;
    const cancelUrl = `${baseUrl}/checkout?error=cancelled&reference=${reference}`;
    const webhookUrl = `${process.env.BACKEND_URL || 'http://localhost:3002'}/api/payments/cobru/webhook`;

    const transactionData = {
      amount: parseFloat(amount),
      currency,
      description,
      reference,
      customerEmail,
      customerName,
      customerPhone,
      returnUrl,
      cancelUrl,
      webhookUrl
    };

    const result = await cobruService.createTransaction(transactionData);

    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error
      });
    }

    // Guardar información de la transacción en la base de datos
    try {
      const db = require('../config/database-postgres');
      
      await db.query(
        `INSERT INTO payment_transactions (
          transaction_id, 
          payment_gateway, 
          amount, 
          currency, 
          status, 
          reference, 
          customer_email, 
          customer_name, 
          customer_phone,
          event_id,
          ticket_type_id,
          quantity,
          payment_url,
          qr_code,
          expires_at,
          created_at
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, NOW())`,
        [
          result.transactionId,
          'cobru',
          amount,
          currency,
          result.status,
          reference,
          customerEmail,
          customerName,
          customerPhone,
          eventId,
          ticketTypeId,
          quantity,
          result.paymentUrl,
          result.qrCode,
          result.expiresAt
        ]
      );
    } catch (dbError) {
      console.error('Error guardando transacción en BD:', dbError);
      // No fallar la transacción por error de BD
    }

    res.json({
      success: true,
      data: {
        transactionId: result.transactionId,
        paymentUrl: result.paymentUrl,
        qrCode: result.qrCode,
        expiresAt: result.expiresAt,
        status: result.status,
        reference: result.reference
      }
    });

  } catch (error) {
    console.error('Error creando transacción Cobru:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor'
    });
  }
});

/**
 * GET /api/payments/cobru/status/:transactionId
 * Obtener estado de una transacción
 */
router.get('/status/:transactionId', async (req, res) => {
  try {
    const { transactionId } = req.params;

    const result = await cobruService.getTransactionStatus(transactionId);

    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error
      });
    }

    res.json({
      success: true,
      data: result
    });

  } catch (error) {
    console.error('Error obteniendo estado Cobru:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor'
    });
  }
});

/**
 * POST /api/payments/cobru/webhook
 * Procesar webhook de Cobru
 */
router.post('/webhook', async (req, res) => {
  try {
    const signature = req.headers['x-signature'] || req.headers['x-cobru-signature'];
    const webhookData = req.body;

    if (!signature) {
      return res.status(400).json({
        success: false,
        error: 'Firma de webhook requerida'
      });
    }

    const result = await cobruService.processWebhook(webhookData, signature);

    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error
      });
    }

    // Actualizar estado en la base de datos
    try {
      const db = require('../config/database-postgres');
      
      await db.query(
        `UPDATE payment_transactions 
         SET status = $1, 
             updated_at = NOW(),
             payment_method = $2,
             transaction_data = $3
         WHERE transaction_id = $4`,
        [
          result.status,
          result.paymentMethod,
          JSON.stringify(webhookData),
          result.transactionId
        ]
      );

      // Si el pago fue exitoso, crear la venta
      if (result.status === 'approved' || result.status === 'completed') {
        await createSaleFromTransaction(result.transactionId);
      }

    } catch (dbError) {
      console.error('Error actualizando transacción en BD:', dbError);
    }

    res.json({
      success: true,
      message: 'Webhook procesado correctamente'
    });

  } catch (error) {
    console.error('Error procesando webhook Cobru:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor'
    });
  }
});

/**
 * POST /api/payments/cobru/refund
 * Procesar reembolso
 */
router.post('/refund', async (req, res) => {
  try {
    const { transactionId, amount, reason } = req.body;

    if (!transactionId) {
      return res.status(400).json({
        success: false,
        error: 'ID de transacción requerido'
      });
    }

    const result = await cobruService.processRefund(transactionId, amount, reason);

    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error
      });
    }

    // Actualizar estado en la base de datos
    try {
      const db = require('../config/database-postgres');
      
      await db.query(
        `INSERT INTO refunds (
          refund_id,
          transaction_id,
          amount,
          reason,
          status,
          created_at
        ) VALUES ($1, $2, $3, $4, $5, NOW())`,
        [
          result.refundId,
          transactionId,
          result.amount,
          reason,
          result.status
        ]
      );
    } catch (dbError) {
      console.error('Error guardando reembolso en BD:', dbError);
    }

    res.json({
      success: true,
      data: result
    });

  } catch (error) {
    console.error('Error procesando reembolso Cobru:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor'
    });
  }
});

/**
 * Función auxiliar para crear venta desde transacción
 */
async function createSaleFromTransaction(transactionId) {
  try {
    const db = require('../config/database-postgres');
    
    // Obtener datos de la transacción
    const transactionResult = await db.query(
      `SELECT * FROM payment_transactions WHERE transaction_id = $1`,
      [transactionId]
    );

    if (transactionResult.rows.length === 0) {
      throw new Error('Transacción no encontrada');
    }

    const transaction = transactionResult.rows[0];

    // Crear la venta
    await db.query(
      `INSERT INTO sales (
        user_id,
        event_id,
        ticket_type_id,
        quantity,
        total_amount,
        payment_method,
        payment_gateway,
        transaction_id,
        status,
        created_at
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, NOW())`,
      [
        transaction.user_id || null,
        transaction.event_id,
        transaction.ticket_type_id,
        transaction.quantity,
        transaction.amount,
        transaction.payment_method || 'cobru',
        'cobru',
        transactionId,
        'completed'
      ]
    );

    console.log(`Venta creada para transacción ${transactionId}`);

  } catch (error) {
    console.error('Error creando venta desde transacción:', error);
  }
}

module.exports = router;
