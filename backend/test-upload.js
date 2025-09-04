const FormData = require('form-data');
const fs = require('fs');
const path = require('path');

async function testUpload() {
  try {
    // Create a test file
    const testFilePath = path.join(__dirname, 'test-image.txt');
    fs.writeFileSync(testFilePath, 'This is a test file for upload');
    
    const formData = new FormData();
    formData.append('files', fs.createReadStream(testFilePath), {
      filename: 'test-image.txt',
      contentType: 'text/plain'
    });

    console.log('Testing upload to: http://localhost:3002/api/admin/media/upload');
    
    const response = await fetch('http://localhost:3002/api/admin/media/upload', {
      method: 'POST',
      body: formData
    });

    const result = await response.json();
    console.log('Upload response:', result);

    // Clean up test file
    fs.unlinkSync(testFilePath);
    
  } catch (error) {
    console.error('Test upload failed:', error);
  }
}

testUpload();
