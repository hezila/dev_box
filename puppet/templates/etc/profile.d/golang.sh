GOPATH="<%= @workdir %>"
GOROOT="<%= @installdir %>/go"
PATH="$GOPATH/bin:<%= @installdir %>/go/bin:$PATH"
export GOPATH GOROOT PATH
