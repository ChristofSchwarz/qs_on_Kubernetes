# https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
FROM node:4.6
WORKDIR /app
COPY package*.json .
RUN npm install
COPY app.js .
EXPOSE 8074
CMD ["node", "app.js"]
