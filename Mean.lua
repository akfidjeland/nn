local Mean, parent = torch.class('nn.Mean', 'nn.Module')

function Mean:__init(dimension)
   parent.__init(self)
   dimension = dimension or 1
   self.dimension = dimension
   self.preoutput = torch.Tensor()
end

function Mean:updateOutput(input)
   self.preoutput:mean(input, self.dimension)
   self.output = self.preoutput:select(self.dimension, 1)
   return self.output
end

function Mean:updateGradInput(input, gradOutput)
   local size = gradOutput:size():totable()
   local stride = gradOutput:stride():totable()
   table.insert(size, self.dimension, input:size(self.dimension))
   table.insert(stride, self.dimension, 0)

   self.gradInput:resizeAs(gradOutput):copy(gradOutput)
   self.gradInput:mul(1/input:size(self.dimension))
   self.gradInput:resize(torch.LongStorage(size), torch.LongStorage(stride))

   return self.gradInput
end
