import { type NextRequest, NextResponse } from "next/server"
import { readFile, writeFile, mkdir, unlink } from "fs/promises"
import { join } from "path"
import { stat } from "fs/promises"

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const path = searchParams.get("path")

    if (!path) {
      return NextResponse.json({ error: "Path parameter required" }, { status: 400 })
    }

    // Security: Only allow specific file extensions and prevent directory traversal
    const allowedExtensions = [".png", ".jpg", ".jpeg", ".svg", ".webp", ".gif", ".ico"]
    const hasAllowedExtension = allowedExtensions.some((ext) => path.toLowerCase().endsWith(ext))

    if (!hasAllowedExtension || path.includes("..") || path.includes("//")) {
      return NextResponse.json({ error: "Invalid file path" }, { status: 400 })
    }

    const filePath = join(process.cwd(), "app/assets", path)

    // Check if file exists
    try {
      await stat(filePath)
    } catch {
      return NextResponse.json({ error: "File not found" }, { status: 404 })
    }

    // Delete the file
    await unlink(filePath)

    return NextResponse.json({
      success: true,
      message: "File deleted successfully",
    })
  } catch (error) {
    console.error("File deletion error:", error)
    return NextResponse.json({ error: "Deletion failed" }, { status: 500 })
  }
}

export async function POST(request: NextRequest) {
  try {
    const formData = await request.formData()
    const files = formData.getAll("files") as File[]

    if (!files || files.length === 0) {
      return NextResponse.json({ error: "No files provided" }, { status: 400 })
    }

    const uploadedFiles = []

    for (const file of files) {
      // Validate file type
      const allowedTypes = ["image/png", "image/jpeg", "image/jpg", "image/svg+xml", "image/webp", "image/gif"]
      if (!allowedTypes.includes(file.type)) {
        return NextResponse.json({ error: `File type ${file.type} not allowed` }, { status: 400 })
      }

      // Validate file size (max 5MB)
      if (file.size > 5 * 1024 * 1024) {
        return NextResponse.json({ error: "File size too large (max 5MB)" }, { status: 400 })
      }

      // Generate unique filename
      const timestamp = Date.now()
      const extension = file.name.split(".").pop()
      const filename = `${timestamp}-${file.name.replace(/[^a-zA-Z0-9.-]/g, "_")}`

      // Ensure uploads directory exists
      const uploadsDir = join(process.cwd(), "app/assets/images/uploads")
      try {
        await mkdir(uploadsDir, { recursive: true })
      } catch (error) {
        // Directory might already exist
      }

      const filePath = join(uploadsDir, filename)
      const buffer = Buffer.from(await file.arrayBuffer())

      await writeFile(filePath, buffer)

      uploadedFiles.push({
        id: timestamp.toString(),
        name: filename,
        originalName: file.name,
        type: file.type.startsWith("image/") ? "image" : "document",
        size: file.size,
        url: `/assets?path=images/uploads/${filename}`,
        uploadDate: new Date().toISOString().split("T")[0],
        tags: [],
      })
    }

    return NextResponse.json({
      success: true,
      files: uploadedFiles,
    })
  } catch (error) {
    console.error("File upload error:", error)
    return NextResponse.json({ error: "Upload failed" }, { status: 500 })
  }
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const path = searchParams.get("path")

    if (!path) {
      return new NextResponse("Path parameter required", { status: 400 })
    }

    // Security: Only allow specific file extensions and prevent directory traversal
    const allowedExtensions = [".png", ".jpg", ".jpeg", ".svg", ".webp", ".gif", ".ico"]
    const hasAllowedExtension = allowedExtensions.some((ext) => path.toLowerCase().endsWith(ext))

    if (!hasAllowedExtension || path.includes("..") || path.includes("//")) {
      return new NextResponse("Invalid file path", { status: 400 })
    }

    const filePath = join(process.cwd(), "app/assets", path)

    // Check if file exists
    try {
      await stat(filePath)
    } catch {
      return new NextResponse("Asset not found", { status: 404 })
    }

    const fileBuffer = await readFile(filePath)
    const contentType = getContentType(path)

    return new NextResponse(fileBuffer, {
      headers: {
        "Content-Type": contentType,
        "Cache-Control": "public, max-age=31536000, immutable",
        ETag: `"${Buffer.from(path).toString("base64")}"`,
      },
    })
  } catch (error) {
    console.error("Asset serving error:", error)
    return new NextResponse("Internal server error", { status: 500 })
  }
}

function getContentType(path: string): string {
  const ext = path.toLowerCase().split(".").pop()
  switch (ext) {
    case "png":
      return "image/png"
    case "jpg":
    case "jpeg":
      return "image/jpeg"
    case "svg":
      return "image/svg+xml"
    case "webp":
      return "image/webp"
    case "gif":
      return "image/gif"
    case "ico":
      return "image/x-icon"
    default:
      return "application/octet-stream"
  }
}
