sqlboiler_version = 4.1.2
sqlboiler_download_url = https://api.github.com/repos/volatiletech/sqlboiler/tarball/v$(sqlboiler_version)

golangci_lint_version = 1.27.0

run:
	go run main.go

lint: .bin/golangci-lint
	.bin/golangci-lint run --config .golangci.yml

generate:  generate-dal

generate-dal: .bin/sqlboiler .bin/sqlboiler-psql
	.bin/sqlboiler .bin/sqlboiler-psql

.bin/golangci-lint:
	mkdir -p .bin
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b .bin v$(golangci_lint_version)

.bin/sqlboiler .bin/sqlboiler-psql:
	mkdir -p .bin
	curl -o .bin/sqlboiler.tar.gz -L $(sqlboiler_download_url)
	tar -xzf .bin/sqlboiler.tar.gz --directory .bin && rm .bin/sqlboiler.tar.gz
	mv .bin/volatiletech-sqlboiler-* .bin/sqlboiler-src
	cd .bin/sqlboiler-src && go build -o ../sqlboiler
	cd .bin/sqlboiler-src/drivers/sqlboiler-psql && go build -o ${CURDIR}/.bin/sqlboiler-psql
	rm -r .bin/sqlboiler-src
