import { embed } from "ai";
import { bedrock } from "./model";
import { env } from "../env";
import { QueryVectorsCommand, S3VectorsClient } from '@aws-sdk/client-s3vectors'
import { config } from "./config";

export interface VectorMetadata {
    id: string
    chunk: string
}

const s3Vectors = new S3VectorsClient({})

export const findRelevantContent = async (query: string) => {
    const text = query.replaceAll('\\n', ' ');
    const { modelId } = config({ modelId: 'amazon.titan-embed-text-v2:0' })
    const { embedding: userQueryEmbedded } = await embed({
        model: bedrock.textEmbeddingModel(modelId),
        value: text,
        providerOptions: {
            bedrock: {
                normalize: true
            }
        },
    });
    const input = {
        indexArn: env.AWS_VECTOR_BUCKET_INDEX_ARN!,
        queryVector: {
            float32: userQueryEmbedded,
        },
        topK: 5,
        returnMetadata: true,
        returnDistance: true,
    }
    const result = await s3Vectors.send(new QueryVectorsCommand(input));

    console.log("result", result)

    if (!result.vectors || result.vectors.length === 0) {
        console.log('No vectors found for the query')
        return []
    }

    return result.vectors.map(v => {
        const metadata = v.metadata as VectorMetadata | undefined
        if (!metadata) {
            throw new Error('Metadata is required in the vector response')
        }

        if (!metadata.id || !metadata.chunk) {
            throw new Error('Vector metadata must contain id and chunk fields')
        }

        return {
            id: metadata.id,
            chunk: metadata.chunk,
            key: v.key,
            distance: v.distance,
        }
    })

}
