DOCKER_SWARM_NODE := `make access-manager-instance`

STACK_NAME=app

swarm-deploy:
	scp docker/docker-compose.yml ${DOCKER_SWARM_NODE}:docker-compose.yml
	ssh ${DOCKER_SWARM_NODE} docker stack deploy --compose-file docker-compose.yml ${STACK_NAME}

swarm-stop:
	ssh ${DOCKER_SWARM_NODE} docker stack rm ${STACK_NAME}

swarm-nodes:
	ssh ${DOCKER_SWARM_NODE} docker node ls

.PHONY: swarm-deploy swarm-stop swarm-nodes
