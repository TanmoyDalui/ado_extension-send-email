import tl = require('azure-pipelines-task-lib/task');

async function run() {
    try {
        const emailSubject: string | undefined = tl.getInput('emailSubject', true);
        if (emailSubject == null || emailSubject == '') {
            tl.setResult(tl.TaskResult.Failed, 'Bad emailSubject was given');
            return;
        }

        const emailBody: string | undefined = tl.getInput('emailBody', true);
        if (emailBody == null || emailBody == '') {
            tl.setResult(tl.TaskResult.Failed, 'Bad emailBody was given');
            return;
        }

        const emailToAddress: string | undefined = tl.getInput('emailToAddress', true);
        if (emailToAddress == null || emailToAddress == '') {
            tl.setResult(tl.TaskResult.Failed, 'Bad emailToAddress was given');
            return;
        }

        const emailCcAddress: string | undefined = tl.getInput('emailCcAddress', true);
        if (emailCcAddress == null || emailCcAddress == '') {
            tl.setResult(tl.TaskResult.Failed, 'Bad emailCcAddress was given');
            return;
        }

        
        console.log('Email To address : ', emailToAddress);
        console.log('Email CC address : ', emailCcAddress);
        console.log('Email subject : ', emailSubject);
        console.log('Email body : ', emailBody);
    }
    catch (err) {
        tl.setResult(tl.TaskResult.Failed, err.message);
    }
}

run();