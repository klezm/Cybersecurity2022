#!/bin/bash

docker run -it cifuzz/jazzer-autofuzz \
    -v $(pwd):/fuzzing \
    net.ripe.rpki:rpki-validator:2.29 \
    "net.ripe.rpki.validator3.rrdp.RrdpParser::notification"

    # net.ripe.rpki:rpki-validator:2.27 \
    # com.mikesamuel:json-sanitizer:1.2.0 \
    # com.google.json.JsonSanitizer::sanitize \
    # --autofuzz_ignore=java.lang.ArrayIndexOutOfBoundsException
    # -v $(pwd)/corpus:/corpus \
    # --keep_going=N    # Stop after N findings

    # https://mvnrepository.com/artifact/net.ripe.rpki/rpki-validator
    # https://repo1.maven.org/maven2/net/ripe/rpki/rpki-validator-app/


export CLASSPATH="$CODESPACE_VSCODE_FOLDER/rpki-validator-3/rpki-validator/src/test/java/net/ripe/rpki/validator3/rrdp/FuzzTest.java"


java -cp jazzer.jar[/classpath_entries] com.code_intelligence.jazzer.Jazzer --target_class=<target class> [args...]
java -cp $CODESPACE_VSCODE_FOLDER/jazzer.jar:$CODESPACE_VSCODE_FOLDER/rpki-validator-3/rpki-validator/src/test/java/net/ripe/rpki/validator3/rrdp/FuzzTest.java com.code_intelligence.jazzer.Jazzer --target_class=src.test.java.net.ripe.rpki.validator3.rrdp.FuzzTest

cifuzz -v -C $CODESPACE_VSCODE_FOLDER/rpki-validator-3 run FuzzTest -- --cp src.test.java.net.ripe.rpki.validator3.rrdp.FuzzTest
cifuzz -v -C $CODESPACE_VSCODE_FOLDER/rpki-validator-3 run net.ripe.rpki.validator3.rrdp.FuzzTest.FuzzTest

cifuzz -v -C $CODESPACE_VSCODE_FOLDER/rpki-validator-3 run --project-dir $CODESPACE_VSCODE_FOLDER/rpki-validator-3/rpki-validator FuzzTest
# cifuzz -v -C $CODESPACE_VSCODE_FOLDER/rpki-validator-3/rpki-validator run FuzzTest
# /src/test/java/net/ripe/rpki/validator3/rrdp/FuzzTest.java
$CODESPACE_VSCODE_FOLDER/rpki-validator-3/rpki-validator/src/test/java/net/ripe/rpki/validator3/rrdp/FuzzTest.java

zip -r repo.zip ../Cybersecurity2022 -x "*/target/debug/*" -x "*/deps/*" -x "*/fuzz/target/*" -x "*/node_modules/*"
