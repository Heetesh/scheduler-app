shell:
    nix --experimental-features 'nix-command flakes' develop

code:
    nix --experimental-features 'nix-command flakes' develop --command sh -c 'code .'



install:
    cd server && poetry install
    cd webapp && yarn install
    # Remember to activate the venv in ./server/.venv

start-backend:
    cd server && \
    poetry env activate && \
    poetry run uvicorn server.main:app --host 0.0.0.0 --port 8000 --reload --app-dir src


start-frontend:
    cd webapp && yarn dev

dev:
    just start-backend & just start-frontend

# dev:
#     (cd server && poetry run uvicorn server.main:app --host 0.0.0.0 --port 8000 --reload) & \
#     (cd webapp && yarn dev) & \
#     wait