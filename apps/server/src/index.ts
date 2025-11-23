import { pipeline } from 'node:stream/promises';
import { config } from "./bedrock/config";
import { streamText } from 'ai';
import { bedrock } from './bedrock/model';
import { findRelevantContent } from './bedrock/query-vector';
import type { APIGatewayProxyEventV2 } from 'aws-lambda';

exports.handler = awslambda.streamifyResponse<APIGatewayProxyEventV2>(
    async (event, responseStream, _context) => {
        try {
            responseStream.setContentType('text/plain; charset=utf-8');
            let prompt = '';
            if (event.body) {
                try {
                    const body = JSON.parse(event.body);
                    if (body.prompt) prompt = body.prompt;
                } catch (e) {
                    console.warn('Failed to parse request body:', e);
                }
            }

            if (!prompt) {
                responseStream.write('Error: No prompt provided');
                responseStream.end();
                return;
            }

            const { modelId } = config({});
            const similarDocuments = await findRelevantContent(prompt);
            const context = similarDocuments.map(doc => doc.chunk).join('\n\n');

            const systemPrompt = `You are a helpful assistant. Answer the user's question using ONLY the context provided below. 
            If the answer is not in the context, say "I don't know" or "The provided context does not contain the answer."
            Do not hallucinate or use outside knowledge.

            Context:
            ${context}`;

            const result = await streamText({
                model: bedrock(modelId),
                system: systemPrompt,
                messages: [
                    { role: "user", content: prompt },
                ],
            });
            await pipeline(result.textStream, responseStream);
            return;

        } catch (error) {
            console.error("Error in handler:", error);
            responseStream.write('Error');
            responseStream.end();
        }
    }
);