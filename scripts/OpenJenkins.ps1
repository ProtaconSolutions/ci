$url = minikube service jenkins-ui -n jenkins --url

if($url -like "http*") {
    Start-Process $url
} else {
    throw "Something went wrong, $url"
}