package main

import (
    "context"
    "fmt"
    "k8s.io/apimachinery/pkg/apis/meta/v1"
    "k8s.io/client-go/kubernetes"
    "k8s.io/client-go/tools/clientcmd"
    "os"
)

func main() {
    var option = ""
    if len(os.Args) > 1 {
        option = os.Args[1]
    }

    // uses the current context in kubeconfig
    fmt.Println("Build Client Config")
    config, _ := clientcmd.BuildConfigFromFlags("", "/Users/gauravt/.kube/config")
    config.Host = fmt.Sprintf("%s:%s", os.Getenv("CONTROL_PLANE_NODE"), "6443")
    fmt.Printf("Using API Host: %s\n", config.Host)
    // creates the clientset
    fmt.Println("Create Client Set")
    clientSet, _ := kubernetes.NewForConfig(config)

    switch option {
        case "nodes" : getNodes(clientSet)
        case "pods" : getPods(clientSet)
        default:
            fmt.Println("Nothing to do")
    }
}

func getNodes(clientSet *kubernetes.Clientset) {
    ni := clientSet.CoreV1().Nodes()
    nodes, err := ni.List(context.TODO(), v1.ListOptions{})

    if err != nil {
        fmt.Println("Error occurred: ", err)
    }

    fmt.Printf("There are %d nodes in the cluster\n", len(nodes.Items))
    for i:= 0; i < len(nodes.Items); i++ {
        fmt.Printf("Node: %s\n", nodes.Items[i].ObjectMeta.Name)
    }
}

func getPods(clientSet *kubernetes.Clientset) {
    // access the API to list pods
    pods, _ := clientSet.CoreV1().Pods("").List(context.TODO(), v1.ListOptions{})
    fmt.Printf("There are %d pods in the cluster\n", len(pods.Items))
}