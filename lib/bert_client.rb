# BertClient usage:
# sentences = [sentence_0, sentence_1] # sentences.size need to <= 256
# response = $bc.encode(sentences) # will return 2d array: vecs[sentences.size][768]
# sentence_1_vectors = PyCall::List.(response[0]).to_a # PyCall::List can convert python's ndarray to ruby's Array
begin
  pyfrom 'bert_serving.client', import: :BertClient
  $bc = BertClient.new
rescue => e
  puts "#{e}\nBertClient init failed.\nTo use bert client, you need to exec bert server first!"
end
