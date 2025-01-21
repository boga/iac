const fs = require('fs');
const core = require('@actions/core');

try {
    const filePath = core.getInput('file-path');
    const fileContent = core.getInput('file-content');

    fs.writeFileSync(filePath, fileContent);
    core.info(`File created at ${filePath}`);
    core.setOutput("file-path", filePath);
} catch (error) {
    core.setFailed(`Failed to create file: ${error.message}`);
}
