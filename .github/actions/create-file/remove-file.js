const fs = require('fs');
const core = require('@actions/core');

const filePath = core.getInput('file-path');
try {
    if (!fs.existsSync(filePath)) {
        core.warning(`File at ${filePath} does not exist`);
        return;
    }

    fs.unlinkSync(filePath);
    core.info(`File removed from ${filePath}`);
} catch (error) {
    core.setFailed(`Failed to remove file: ${error.message}`);
}
