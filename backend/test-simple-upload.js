const FormData = require('form-data');
const fs = require('fs');
const path = require('path');

async function testSimpleUpload() {
  try {
    // Create a simple test file
    const testFilePath = path.join(__dirname, 'test.txt');
    fs.writeFileSync(testFilePath, 'Test content');
    
    const formData = new FormData();
    formData.append('files', fs.createReadStream(testFilePath), {
      filename: 'test.txt',
      contentType: 'text/plain'
    });

    console.log('Testing upload...');
    
    const response = await fetch('http://localhost:3002/api/admin/media/upload', {
      method: 'POST',
      body: formData
    });

    console.log('Response status:', response.status);
    const result = await response.text();
    console.log('Response body:', result);

    // Clean up
    fs.unlinkSync(testFilePath);
    
  } catch (error) {
    console.error('Test failed:', error.message);
  }
}

testSimpleUpload();
