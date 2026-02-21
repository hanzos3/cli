## s3 (Hanzo S3 CLI) name conflicts

The `s3` command name may conflict with other tools on your system. If you experience conflicts, you can rename the binary:

```
mv ./s3 ./hanzos3
```

The `s3` binary is a single static binary and can reside inside your application directory. It is fully self contained.
