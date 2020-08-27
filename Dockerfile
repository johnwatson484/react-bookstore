# Development
FROM node:14.8.0-alpine AS development
ENV NODE_ENV development
ARG APP_PORT=3000
ARG API_PORT=3001
ENV APP_PORT ${APP_PORT}
ENV API_PORT ${API_PORT}
EXPOSE ${APP_PORT} ${API_PORT} 9229

# Set global npm dependencies to be stored under the node user directory
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin

USER node
WORKDIR /home/node
COPY --chown=node:node package*.json ./
RUN npm install --production=false
COPY --chown=node:node . .
CMD [ "npm", "run", "start:watch" ]

# Production
FROM development AS production
ENV NODE_ENV production
RUN npm ci
CMD [ "npm", "run", "start" ]
