# ---- Build Stage ----
FROM public.ecr.aws/lambda/nodejs:22 AS builder

WORKDIR /usr/src/app
RUN corepack enable

COPY package.json pnpm-lock.yaml* ./

RUN pnpm install --frozen-lockfile

COPY . .

RUN pnpm run build

# ---- Runtime Stage ----
FROM public.ecr.aws/lambda/nodejs:22

WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=builder /usr/src/app/dist/ ./
COPY --from=builder /usr/src/app/node_modules ./node_modules

ENTRYPOINT [ "/lambda-entrypoint.sh", "index.handler" ]