VERSION=0.1.0
IMAGE_ID=reaandrew/origin
IMAGE_NAME=origin

.PHONY: build
build:
	docker build -t reaandrew/origin ./

.PHONY: build_scratch
build_scratch:
	docker build -t reaandrew/origin_scratch -f ./Scratch .


.PHONY: publish
publish:
	echo ${GITHUB_TOKEN} | docker login docker.pkg.github.com -u reaandrew --password-stdin
	docker tag $(IMAGE_ID) docker.pkg.github.com/reaandrew/origin/$(IMAGE_NAME):$(VERSION)
	docker push docker.pkg.github.com/reaandrew/origin/$(IMAGE_NAME):$(VERSION)
