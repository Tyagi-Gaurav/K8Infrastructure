package main

import (
    "context"
    "fmt"
    "k8s.io/apimachinery/pkg/apis/meta/v1"
    "k8s.io/client-go/kubernetes"
    "k8s.io/client-go/tools/clientcmd"
)

func main() {
    // uses the current context in kubeconfig
    fmt.Println("Build Client Config")
    config, _ := clientcmd.BuildConfigFromFlags("", "/Users/gauravt/.kube/config")
    // creates the clientset
    fmt.Println("Create Client Set")
    clientset, _ := kubernetes.NewForConfig(config)
    // access the API to list pods
    fmt.Println("Get Pods")
    pods, _ := clientset.CoreV1().Pods("").List(context.TODO(), v1.ListOptions{})
    fmt.Printf("There are %d pods in the cluster\n", len(pods.Items))
}