# http://localhost:4566/_floci/ui
# To set AWS environment variables for local testing with Floci:
export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
# or just make an alias for it
alias awslocal='AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1 aws --endpoint-url=http://localhost:4566'

# List running instances, names, and IP addresses:
awslocal ec2 describe-instances \
  --query "Reservations[].Instances[].{InstanceId:InstanceId,Name:Tags[?Key=='Name'].Value|[0],State:State.Name,PrivateIp:PrivateIpAddress,PublicIp:PublicIpAddress}" \
  --output table

# List floci-ec2 container:
docker ps --filter "name=floci-ec2"

# Show all Floci containers, their IPs, and mapped ports:
for cid in $(docker ps -q --filter "name=floci-"); do
  name=$(docker inspect -f '{{.Name}}' "$cid" | sed 's|^/||')
  bridge_ip=$(docker inspect -f '{{range $k, $v := .NetworkSettings.Networks}}{{if eq $k "bridge"}}{{$v.IPAddress}}{{end}}{{end}}' "$cid")
  vpc_ip=$(docker inspect -f '{{range $k, $v := .NetworkSettings.Networks}}{{if ne $k "bridge"}}{{$v.IPAddress}}{{end}}{{end}}' "$cid")
  ports=$(docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}}{{if $conf}}{{$p}} -> {{range $conf}}{{.HostIp}}:{{.HostPort}} {{end}}; {{else}}{{$p}} (internal); {{end}}{{end}}' "$cid")
  printf "%-42s | Bridge IP: %-12s | VPC IP: %-10s | Ports: %s\n" "$name" "$bridge_ip" "$vpc_ip" "$ports"
done

# Quick access:
# Jenkins: http://$(docker inspect -f '{{.NetworkSettings.IPAddress}}' $(docker ps -q --filter "name=floci-ec2")):8080
# Gogs:    http://$(docker inspect -f '{{.NetworkSettings.IPAddress}}' $(docker ps -q --filter "name=floci-ecs")):3000


# get floci cert
curl -o floci-ca.pem http://localhost:4566/_floci/ca.pem
# add cert to trust store
/usr/local/share/ca-certificates/

# on ubuntu need rename
sudo mv /usr/local/share/ca-certificates/floci-ca.pem /usr/local/share/ca-certificates/floci-ca.crt