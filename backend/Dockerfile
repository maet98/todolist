FROM node:12.19.0-alpine3.9 AS development

COPY package*.json ./

RUN npm install --only=development

COPY . .

RUN npm run build

CMD ["node", "dist/main"]
