const express = require("express")
const multer = require("multer")
const path = require("path")
const fs = require("fs")
const db = require("../config/database-postgres")
const { auth, requireRole } = require("../middleware/auth")

const router = express.Router()

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = path.join(__dirname, '../uploads')
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true })
    }
    cb(null, uploadDir)
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname))
  }
})

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit
  },
  fileFilter: (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|gif|svg|mp4|avi|mov|mp3|wav|pdf|doc|docx/
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase())
    const mimetype = allowedTypes.test(file.mimetype)

    if (mimetype && extname) {
      return cb(null, true)
    } else {
      cb(new Error('Only image, video, audio, and document files are allowed'))
    }
  }
})

// Get all media files
router.get("/", auth, requireRole("admin"), async (req, res) => {
  try {
    const query = `
      SELECT 
        m.*,
        mf.name as folder_name
      FROM media m
      LEFT JOIN media_folders mf ON m.folder_id = mf.id
      ORDER BY m.upload_date DESC
    `

    const result = await db.query(query)

    res.json({
      success: true,
      data: result.rows,
    })
  } catch (error) {
    console.error("Get media error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Get single media file
router.get("/:id", auth, requireRole("admin"), async (req, res) => {
  try {
    const query = `
      SELECT 
        m.*,
        mf.name as folder_name
      FROM media m
      LEFT JOIN media_folders mf ON m.folder_id = mf.id
      WHERE m.id = $1
    `

    const result = await db.query(query, [req.params.id])

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Media file not found",
      })
    }

    res.json({
      success: true,
      data: result.rows[0],
    })
  } catch (error) {
    console.error("Get media error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Upload media files
router.post("/upload", auth, requireRole("admin"), upload.array('files', 10), async (req, res) => {
  try {
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({
        success: false,
        message: "No files uploaded",
      })
    }

    const uploadedFiles = []

    for (const file of req.files) {
      const fileType = getFileType(file.mimetype)
      const fileUrl = `/uploads/${file.filename}`

      const query = `
        INSERT INTO media (name, original_name, type, size, url, folder_id, upload_date)
        VALUES ($1, $2, $3, $4, $5, $6, CURRENT_TIMESTAMP)
        RETURNING *
      `

      const result = await db.query(query, [
        file.filename,
        file.originalname,
        fileType,
        file.size,
        fileUrl,
        req.body.folder_id || null
      ])

      uploadedFiles.push(result.rows[0])
    }

    res.status(201).json({
      success: true,
      message: `${uploadedFiles.length} file(s) uploaded successfully`,
      data: uploadedFiles,
    })
  } catch (error) {
    console.error("Upload media error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Create media file (metadata only)
router.post("/", auth, requireRole("admin"), async (req, res) => {
  try {
    const { name, original_name, type, size, url, folder_id, alt, description, tags } = req.body

    if (!name || !type || !url) {
      return res.status(400).json({
        success: false,
        message: "Name, type, and URL are required",
      })
    }

    const query = `
      INSERT INTO media (name, original_name, type, size, url, folder_id, alt, description, tags, upload_date)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, CURRENT_TIMESTAMP)
      RETURNING *
    `

    const result = await db.query(query, [
      name,
      original_name,
      type,
      size || 0,
      url,
      folder_id || null,
      alt,
      description,
      tags ? JSON.stringify(tags) : null
    ])

    res.status(201).json({
      success: true,
      message: "Media file created successfully",
      data: result.rows[0],
    })
  } catch (error) {
    console.error("Create media error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Update media file
router.put("/:id", auth, requireRole("admin"), async (req, res) => {
  try {
    const { name, alt, description, tags, folder_id } = req.body

    const query = `
      UPDATE media 
      SET name = COALESCE($1, name),
          alt = COALESCE($2, alt),
          description = COALESCE($3, description),
          tags = COALESCE($4, tags),
          folder_id = COALESCE($5, folder_id),
          updated_at = CURRENT_TIMESTAMP
      WHERE id = $6
      RETURNING *
    `

    const result = await db.query(query, [
      name,
      alt,
      description,
      tags ? JSON.stringify(tags) : null,
      folder_id,
      req.params.id
    ])

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Media file not found",
      })
    }

    res.json({
      success: true,
      message: "Media file updated successfully",
      data: result.rows[0],
    })
  } catch (error) {
    console.error("Update media error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Delete media file
router.delete("/:id", auth, requireRole("admin"), async (req, res) => {
  try {
    // Get file info before deletion
    const fileQuery = await db.query("SELECT url FROM media WHERE id = $1", [req.params.id])
    
    if (fileQuery.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Media file not found",
      })
    }

    const fileUrl = fileQuery.rows[0].url
    const filePath = path.join(__dirname, '..', fileUrl)

    // Delete from database
    const result = await db.query("DELETE FROM media WHERE id = $1 RETURNING *", [req.params.id])

    // Delete physical file
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath)
    }

    res.json({
      success: true,
      message: "Media file deleted successfully",
    })
  } catch (error) {
    console.error("Delete media error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Get media folders
router.get("/folders", auth, requireRole("admin"), async (req, res) => {
  try {
    const query = `
      SELECT 
        mf.*,
        COUNT(m.id) as file_count
      FROM media_folders mf
      LEFT JOIN media m ON mf.id = m.folder_id
      GROUP BY mf.id
      ORDER BY mf.name ASC
    `

    const result = await db.query(query)

    res.json({
      success: true,
      data: result.rows,
    })
  } catch (error) {
    console.error("Get media folders error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Create media folder
router.post("/folders", auth, requireRole("admin"), async (req, res) => {
  try {
    const { name, parent_id } = req.body

    if (!name) {
      return res.status(400).json({
        success: false,
        message: "Folder name is required",
      })
    }

    const query = `
      INSERT INTO media_folders (name, parent_id, created_date)
      VALUES ($1, $2, CURRENT_TIMESTAMP)
      RETURNING *
    `

    const result = await db.query(query, [name, parent_id || null])

    res.status(201).json({
      success: true,
      message: "Media folder created successfully",
      data: result.rows[0],
    })
  } catch (error) {
    console.error("Create media folder error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Delete media folder
router.delete("/folders/:id", auth, requireRole("admin"), async (req, res) => {
  try {
    // Check if folder has files
    const fileCheck = await db.query("SELECT COUNT(*) FROM media WHERE folder_id = $1", [req.params.id])

    if (Number.parseInt(fileCheck.rows[0].count) > 0) {
      return res.status(409).json({
        success: false,
        message: "Cannot delete folder with files",
      })
    }

    const result = await db.query("DELETE FROM media_folders WHERE id = $1 RETURNING *", [req.params.id])

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Media folder not found",
      })
    }

    res.json({
      success: true,
      message: "Media folder deleted successfully",
    })
  } catch (error) {
    console.error("Delete media folder error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Helper function to determine file type
function getFileType(mimetype) {
  if (mimetype.startsWith('image/')) return 'image'
  if (mimetype.startsWith('video/')) return 'video'
  if (mimetype.startsWith('audio/')) return 'audio'
  return 'document'
}

module.exports = router
