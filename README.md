bootstrap
=========

macOS

### generate ssh key (if needed)
`ssh-keygen -t ed25519 -C "you@example.com"`

### start ssh agent + add key to keychain
`eval "$(ssh-agent -s)"`
`ssh-add --apple-use-keychain ~/.ssh/id_ed25519`

### verify github ssh access
`ssh -T git@github.com`

### clone bootstrap repo
`git clone git@github.com:brenj/bootstrap.git`
`cd bootstrap`

### run provisioning
`./macOS/provision.sh`