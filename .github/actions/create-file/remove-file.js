const fs = require('fs');
const core = require('@actions/core');

try {
    const filePath = core.getInput('file-path');

    if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        core.info(`File removed from ${filePath}`);
    } else {
        core.info(`File at ${filePath} does not exist`);
    }
} catch (error) {
    core.setFailed(`Failed to remove file: ${error.message}`);
}
