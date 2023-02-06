Bei mir rot unterlegt
* [`decode(ChannelHandlerContext ctx, ByteBuf in, List<Object> out)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/adapter/netty/PduCodec.java#L71)
* [`data(T data)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/api/ApiResponse.java#L58)
* [`data(Links links, T data)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/api/ApiResponse.java#L62)
* [`schedule(Class<? extends Job> jobClass, Date startAt, ScheduleBuilder<T> schedule)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/background/BackgroundJobs.java#L76)

Bei mir gelb unterlegt
* [`checkLenght(ByteBuf in, int expectedLength, String pduType, BiFunction<ErrorCode, String, ErrorPdu> generateError)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/adapter/netty/PduCodec.java#L228)
* [`of(HttpStatus status, String detail)`]()
* [`of(ProtocolVersion protocolVersion, ErrorCode errorCode, byte[] causingPdu, String errorText)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/domain/pdus/ErrorPdu.java#L52)

(Noch) nicht farblich unterlegt
* [`of(int errorCode)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/domain/pdus/ErrorCode.java#L57)
* [`of(byte value)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/domain/pdus/ProtocolVersion.java#L53)
* [`cacheUpdated(short sessionId, SerialNumber updatedSerialNumber)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/domain/RtrClient.java#L41)
* [`register(final RtrClient client)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/domain/RtrClients.java#L77)
* [`unregister(RtrClient client)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/domain/RtrClients.java#L89)
* [`cacheUpdated(short sessionId, SerialNumber updatedSerialNumber)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/domain/RtrClients.java#L101)
* [`parse(String hex)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/util/Hex.java#L33)
* [`format(byte[] bytes)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/util/Hex.java#L45)
* [`hash(byte[] data)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/util/Sha256.java#L40)
* [`sendNotifyPduIfNeeded(short sessionId, SerialNumber updatedSerialNumber)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/RtrClientHandler.java#L305)
* [`setAdress(String address)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/RtrServer.java#L89)
* [`setPort(int port)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/RtrServer.java#L93)
* [`main(String[] args)`](https://vscode.dev/github/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-rtr-server/src/main/java/net/ripe/rpki/rtr/RtrServerApplication.java#L192)