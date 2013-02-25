class Replace < Nanoc::Filter
  identifier :replace
  type :text

  def run(content, params = { })
    content.gsub params[:pattern], params[:replacement]
  end
end
