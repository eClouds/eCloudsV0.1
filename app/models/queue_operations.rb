class QueueOperations
  @@sqs = Aws::Sqs.new(AMAZON_ACCESS_KEY_ID, AMAZON_SECRET_ACCESS_KEY)

  # To change this template use File | Settings | File Templates.
  def sendMessage(queue,message)
     return queue.send_message(message)
  end

  def receiveMessage(queue)
    return queue.receive
  end

  def createQueue(queue_name)

    return @@sqs.queue(@queue_name, true, 1)
  end

  def getQueue(queue_name)
    return @@sqs.queue(queue_name,false)
  end

end