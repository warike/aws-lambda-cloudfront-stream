import { env } from "../env";

const DEFAULT_REGION = env.AWS_REGION;
const DEFAULT_MODEL = env.AWS_BEDROCK_MODEL;

export type Configuration = {
  regionId?: string;
  modelId?: string;
};

export const config = ({ regionId, modelId }: Configuration) => {
  const model = modelId || DEFAULT_MODEL;
  const region = regionId || DEFAULT_REGION;

  return {
    regionId: region,
    modelId: model
  };
};