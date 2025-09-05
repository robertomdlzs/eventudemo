const crypto = require('crypto');

class CobruService {
  constructor() {
    this.apiUrl = process.env.COBRU_API_URL || 'https://api.cobru.co';
    this.apiKey = process.env.COBRU_API_KEY;
    this.secretKey = process.env.COBRU_SECRET_KEY;
    this.merchantId = process.env.COBRU_MERCHANT_ID;
    this.environment = process.env.COBRU_ENVIRONMENT || 'sandbox'; // sandbox o production
  }

  /**
   * Crear una transacción de pago con Cobru
   */
  async createTransaction(transactionData) {
    try {
      const {
        amount,
        currency = 'COP',
        description,
        reference,
        customerEmail,
        customerName,
        customerPhone,
        returnUrl,
        cancelUrl,
        webhookUrl
      } = transactionData;

      // Validar datos requeridos
      if (!amount || !description || !reference) {
        throw new Error('Faltan datos requeridos para la transacción');
      }

      // Preparar payload para Cobru
      const payload = {
        amount: Math.round(amount * 100), // Cobru espera el monto en centavos
        currency: currency,
        description: description,
        reference: reference,
        customer: {
          email: customerEmail,
          name: customerName,
          phone: customerPhone
        },
        urls: {
          return: returnUrl,
          cancel: cancelUrl,
          webhook: webhookUrl
        },
        environment: this.environment
      };

      // Generar firma de seguridad
      const signature = this.generateSignature(payload);

      const response = await fetch(`${this.apiUrl}/v1/payments`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.apiKey}`,
          'X-Signature': signature,
          'X-Merchant-ID': this.merchantId
        },
        body: JSON.stringify(payload)
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`Error de Cobru: ${errorData.message || 'Error desconocido'}`);
      }

      const result = await response.json();
      
      return {
        success: true,
        transactionId: result.id,
        paymentUrl: result.payment_url,
        qrCode: result.qr_code,
        expiresAt: result.expires_at,
        status: result.status,
        reference: result.reference
      };

    } catch (error) {
      console.error('Error creando transacción Cobru:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }

  /**
   * Verificar el estado de una transacción
   */
  async getTransactionStatus(transactionId) {
    try {
      const response = await fetch(`${this.apiUrl}/v1/payments/${transactionId}`, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'X-Merchant-ID': this.merchantId
        }
      });

      if (!response.ok) {
        throw new Error('Error obteniendo estado de transacción');
      }

      const result = await response.json();
      
      return {
        success: true,
        transactionId: result.id,
        status: result.status,
        amount: result.amount,
        currency: result.currency,
        reference: result.reference,
        createdAt: result.created_at,
        updatedAt: result.updated_at,
        paymentMethod: result.payment_method,
        transactionData: result.transaction_data
      };

    } catch (error) {
      console.error('Error obteniendo estado Cobru:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }

  /**
   * Procesar webhook de Cobru
   */
  async processWebhook(webhookData, signature) {
    try {
      // Verificar firma del webhook
      if (!this.verifyWebhookSignature(webhookData, signature)) {
        throw new Error('Firma de webhook inválida');
      }

      const {
        event_type,
        transaction_id,
        status,
        amount,
        reference,
        payment_method,
        timestamp
      } = webhookData;

      return {
        success: true,
        eventType: event_type,
        transactionId: transaction_id,
        status: status,
        amount: amount,
        reference: reference,
        paymentMethod: payment_method,
        timestamp: timestamp
      };

    } catch (error) {
      console.error('Error procesando webhook Cobru:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }

  /**
   * Generar firma de seguridad para las peticiones
   */
  generateSignature(payload) {
    const payloadString = JSON.stringify(payload);
    const signature = crypto
      .createHmac('sha256', this.secretKey)
      .update(payloadString)
      .digest('hex');
    
    return signature;
  }

  /**
   * Verificar firma del webhook
   */
  verifyWebhookSignature(payload, signature) {
    const expectedSignature = this.generateSignature(payload);
    return crypto.timingSafeEqual(
      Buffer.from(signature, 'hex'),
      Buffer.from(expectedSignature, 'hex')
    );
  }

  /**
   * Obtener configuración de Cobru
   */
  getConfig() {
    return {
      apiUrl: this.apiUrl,
      environment: this.environment,
      merchantId: this.merchantId,
      supportedCurrencies: ['COP', 'USD'],
      supportedPaymentMethods: [
        'nequi',
        'daviplata',
        'bancolombia',
        'bancolombia_transfer',
        'efecty',
        'baloto',
        'redservi',
        'pse'
      ],
      features: {
        qrCode: true,
        webhooks: true,
        refunds: true,
        partialRefunds: true
      }
    };
  }

  /**
   * Procesar reembolso
   */
  async processRefund(transactionId, amount = null, reason = '') {
    try {
      const payload = {
        transaction_id: transactionId,
        amount: amount ? Math.round(amount * 100) : null, // Si no se especifica, reembolso total
        reason: reason
      };

      const signature = this.generateSignature(payload);

      const response = await fetch(`${this.apiUrl}/v1/refunds`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.apiKey}`,
          'X-Signature': signature,
          'X-Merchant-ID': this.merchantId
        },
        body: JSON.stringify(payload)
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`Error procesando reembolso: ${errorData.message}`);
      }

      const result = await response.json();
      
      return {
        success: true,
        refundId: result.id,
        status: result.status,
        amount: result.amount,
        transactionId: result.transaction_id,
        createdAt: result.created_at
      };

    } catch (error) {
      console.error('Error procesando reembolso Cobru:', error);
      return {
        success: false,
        error: error.message
      };
    }
  }
}

module.exports = CobruService;
