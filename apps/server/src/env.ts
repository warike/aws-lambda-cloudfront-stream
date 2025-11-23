// src/env.ts
import { z } from "zod";
import * as dotenv from "dotenv";

dotenv.config();

const envSchema = z.object({
    NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
    AWS_REGION: z.string().default("us-west-2"),
    AWS_BEDROCK_MODEL: z.string().default("amazon.nova-micro-v1:0"),
    AWS_BEDROCK_MODEL_EMBEDDING: z.string().default("amazon.titan-embed-text-v2:0"),
    AWS_VECTOR_BUCKET_INDEX_ARN: z.string().default("arn:aws:s3vectors:us-west-2:123456789012:index/your-index-name"),
});

const _env = envSchema.safeParse(process.env);

if (!_env.success) {
    console.error("❌ Invalid environment variables:", _env.error.flatten().fieldErrors);
    process.exit(1);
}

export const env = _env.data;