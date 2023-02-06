package net.ripe.rpki.validator3.rrdp;
// package .;

import com.code_intelligence.jazzer.api.FuzzedDataProvider;
import com.code_intelligence.jazzer.junit.FuzzTest;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.assertEquals;

public class FuzzTest {
    @FuzzTest
    void myFuzzTest(FuzzedDataProvider data) {
        // Call the functions you want to test with the provided data and optionally
        // assert that the results are as expected.

        // If you want to know more about writing fuzz tests you can checkout the
        // example projects at https://github.com/CodeIntelligenceTesting/cifuzz/tree/main/examples
        // or have a look at our tutorial:
        // https://github.com/CodeIntelligenceTesting/cifuzz/blob/main/docs/How-To-Write-A-Fuzz-Test.md


        // final Notification notification = new RrdpParser().notification(fileIS("rrdp/notification1.xml"));
        final Notification notification = new RrdpParser().notification((InputStream) data);
        // assertEquals("9df4b597-af9e-4dca-bdda-719cce2c4e28", notification.sessionId);
        // assertEquals("http://repo.net/repo/snapshot.xml", notification.snapshotUri);
        // assertEquals("EEEA7F7AD96D85BBD1F7274FA7DA0025984A2AF3D5A0538F77BEC732ECB1B068", notification.snapshotHash);
        // assertEquals(BigInteger.ONE, notification.serial);
        // assertEquals(0, notification.deltas.size());
    }

    private static InputStream fileIS(String path) throws IOException {
        return Thread.currentThread().getContextClassLoader().getResourceAsStream(path);
    }
}
