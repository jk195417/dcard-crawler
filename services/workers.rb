class Workers
  attr_accessor :thread_number, :tasks, :workers

  def initialize(thread_number: 100)
    @thread_number = thread_number
    @tasks = Queue.new
  end

  def add_task(&task)
    @tasks << task
  end

  def work
    @workers = Array.new(@thread_number) do
      Thread.new do
        @tasks.pop.call until @tasks.empty?
      end
    end
    @workers.each(&:join)
  end
end
