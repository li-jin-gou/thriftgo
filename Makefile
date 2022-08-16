# Copyright 2022 CloudWeGo Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

OUT=$(PWD)/testdata
IDL=$(OUT)/x.thrift
COV_PROF=$(OUT)/cov.out

export IDL

.PHONY: all clean
all: lint test bench

lint:
	go install mvdan.cc/gofumpt@v0.2.0
	test -z "$$(gofumpt -l -extra .)" 
	go vet -stdmethods=false $$(go list ./...)

bench:
	go test -bench=. -benchmem -run=none ./...

test:
	go test -race -covermode=atomic -coverprofile=$(COV_PROF) ./...

thriftgo:
	go install

testall: thriftgo
	@for d in test/*; do $(MAKE) -C $$d; done

clean:
	rm -rf $(COV_PROF) $(IDL)
