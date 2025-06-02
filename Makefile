environment = local

setup:
	ansible-playbook --vault-id password ansible/playbooks/up.yaml -i ansible/$(environment)-hosts.yaml

docker-up:
	docker compose up --detach --build

docker-up-force:
	docker compose rm -fs
	make docker-up

docker-php-cli:
	docker compose exec php-cli zsh

ansible-view:
	ansible-vault view --vault-id password ansible/vars/$(environment).vault.yaml

ansible-decrypt:
	ansible-vault decrypt --vault-id password ansible/vars/$(environment).vault.yaml

ansible-encrypt:
	ansible-vault encrypt --vault-id password ansible/vars/$(environment).vault.yaml
