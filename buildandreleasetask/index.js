"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const tl = require("azure-pipelines-task-lib/task");
function run() {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            const emailSubject = tl.getInput('emailSubject', true);
            if (emailSubject == null || emailSubject == '') {
                tl.setResult(tl.TaskResult.Failed, 'Bad emailSubject was given');
                return;
            }
            const emailBody = tl.getInput('emailBody', true);
            if (emailBody == null || emailBody == '') {
                tl.setResult(tl.TaskResult.Failed, 'Bad emailBody was given');
                return;
            }
            const emailToAddress = tl.getInput('emailToAddress', true);
            if (emailToAddress == null || emailToAddress == '') {
                tl.setResult(tl.TaskResult.Failed, 'Bad emailToAddress was given');
                return;
            }
            const emailCcAddress = tl.getInput('emailCcAddress', true);
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
    });
}
run();
