from constructs import Construct
from cdk8s import Chart
from imports.k8s import *
import os

ENV_NAME = os.environ["ENV_NAME"]

class simpleApp(Chart):
    def __init__(self, scope: Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        # Namespace
        KubeNamespace(self, 'Namespace',
            metadata=ObjectMeta(name=ENV_NAME)
        )

        # Deployment
        KubeDeployment(self, 'Deployment',
            metadata=ObjectMeta(
                name=f'{ENV_NAME}-sample',
                namespace=ENV_NAME  # Explicitly specifying the namespace
            ),
            spec=DeploymentSpec(
                replicas=1,
                selector=LabelSelector(match_labels={'app': 'hello'}),
                template=PodTemplateSpec(
                    metadata=ObjectMeta(labels={'app': 'hello'}),
                    spec=PodSpec(containers=[
                        Container(
                            name='hello',
                            image='mendhak/http-https-echo:34',
                            ports=[ContainerPort(container_port=8080, name='http')]
                        )
                    ])
                )
            )
        )

        # Service
        KubeService(self, 'Service',
            metadata=ObjectMeta(
                name=f'{ENV_NAME}-sample',
                namespace=ENV_NAME  # Explicitly specifying the namespace
            ),
            spec=ServiceSpec(
                type='ClusterIP',
                selector={'app': 'hello'},
                ports=[ServicePort(protocol='TCP', port=80, target_port=IntOrString.from_number(8080))]
            )
        )

        # Ingress
        KubeIngress(self, 'Ingress',
            metadata=ObjectMeta(
                name=f'{ENV_NAME}-sample',
                namespace=ENV_NAME,
                annotations={
                    'nginx.ingress.kubernetes.io/rewrite-target': '/$2'
                }
            ),
            spec=IngressSpec(
                rules=[IngressRule(
                    http=HttpIngressRuleValue(
                        paths=[HttpIngressPath(
                            path=f'/{ENV_NAME}',
                            path_type='Prefix',
                            backend=IngressBackend(
                                service=IngressServiceBackend(
                                    name=f'{ENV_NAME}-sample',
                                    port=ServiceBackendPort(number=80)
                                )
                            )
                        )]
                    )
                )]
            )
        )

# App instantiation
from cdk8s import App
app = App()
simpleApp(app, "sample-app")
app.synth()
