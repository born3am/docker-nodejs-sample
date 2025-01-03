### Building and running your application

When you're ready, start your application by running:
`docker compose up --build`.

Your application will be available at http://localhost:3000. (or the port you specified in the .env file)

### Deploying your application to the cloud

First, build your image, e.g.: `docker build -t myapp .`.
If your cloud uses a different CPU architecture than your development
machine (e.g., you are on a Mac M1 and your cloud provider is amd64),
you'll want to build the image for that platform, e.g.:
`docker build --platform=linux/amd64 -t myapp .`.

Then, push it to your registry, e.g. `docker push myregistry.com/myapp`.

Consult Docker's [getting started](https://docs.docker.com/go/get-started-sharing/)
docs for more detail on building and pushing.

### Test your Node.js deployment using Kubernetes
In this section, you'll learn how to use Docker Desktop to deploy your application to a fully-featured Kubernetes environment on your development machine. This allows you to test and debug your workloads on Kubernetes locally before deploying.
https://docs.docker.com/guides/nodejs/deploy/

## Deploy and check your application
1. In a terminal, navigate to where you created docker-node-kubernetes.yaml and deploy your application to Kubernetes.
```bash
kubectl apply -f docker-node-kubernetes.yaml
```

You should see output that looks like the following, indicating your Kubernetes objects were created successfully.

```bash
deployment.apps/docker-nodejs-demo created
service/todo-entrypoint created
```

2. Make sure everything worked by listing your deployments.

```
kubectl get deployments
```

Your deployment should be listed as follows:

```
NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
docker-nodejs-demo   1/1     1            1           6s
```

This indicates all one of the pods you asked for in your YAML are up and running. Do the same check for your services.

```
 kubectl get services
```

You should get output like the following.

```
NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
kubernetes        ClusterIP   10.96.0.1        <none>        443/TCP          7d22h
todo-entrypoint   NodePort    10.111.101.229   <none>        3000:30001/TCP   33s
```

In addition to the default kubernetes service, you can see your todo-entrypoint service, accepting traffic on port 30001/TCP.

3. Open a browser and visit your app at `localhost:30001`. You should see your application.

4. Run the following command to tear down your application.

```
 kubectl delete -f docker-node-kubernetes.yaml
```

## Summary Kubernetes
In this section, you learned how to use Docker Desktop to deploy your application to a fully-featured Kubernetes environment on your development machine.




### References
* [Docker's Node.js guide](https://docs.docker.com/language/nodejs/)