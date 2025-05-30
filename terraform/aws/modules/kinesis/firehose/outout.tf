output "delivery_stream_arn" {
  value = aws_kinesis_firehose_delivery_stream.firehose_delivery_stream.arn
}

output "delivery_stream_name" {
  value = aws_kinesis_firehose_delivery_stream.firehose_delivery_stream.name
}