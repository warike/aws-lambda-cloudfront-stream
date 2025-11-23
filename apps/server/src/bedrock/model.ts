import { createAmazonBedrock } from '@ai-sdk/amazon-bedrock';
import { fromNodeProviderChain } from '@aws-sdk/credential-providers';
import { config } from './config';

const { regionId } = config({});

export const bedrock = createAmazonBedrock({
    region: regionId,
    credentialProvider: fromNodeProviderChain()
});
