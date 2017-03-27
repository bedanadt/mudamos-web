filename = undefined
revert = undefined
invertExifValues = ['right-top', 'left-bottom']
imageOrientation = undefined

$ ->
  $("form").each ->
    if $(this).find('input.image-upload[type="file"]').length > 0
      input = $(this).find('input.image-upload[type="file"]')

      button = $(this).find('button.upload-image')
      img_wrapper = $(this).find('.file-input-image')

      button.click (e) =>
        e.preventDefault()
        input.click (e) =>
          e.stopPropagation()
        input.click()


      input.change (e) =>
        file = e.target.files[0]

        if file
          reader = new FileReader()
          reader.onload = ->
            img_wrapper
              .removeClass("default")
              .css("background-image": "none")
              .css("background-image": "url('#{reader.result}')")

          reader.readAsDataURL file


getAndTruncateFilenameFromFileInput = (fullPath) ->
  lengthToTruncate = 20
  truncatedFilename

  if fullPath
    startIndex = if (fullPath.indexOf('\\') >= 0) then fullPath.lastIndexOf('\\') else fullPath.lastIndexOf('/')
    filename = fullPath.substring(startIndex)
    if filename.indexOf('\\') == 0 || filename.indexOf('/') == 0
      filename = filename.substring(1)

    if filename.length > lengthToTruncate
      truncatedFilename = '…' + filename.substring((filename.length - lengthToTruncate), filename.length)
    else
      truncatedFilename = filename

    return truncatedFilename

after_image_load = (image, data) ->
  exifOrientation = data.exif.getAll().Orientation if data.exif? and data.exif.getAll()?
  revert = ($.inArray(exifOrientation, invertExifValues) >= 0)

  image.addClass exifOrientation if exifOrientation?
  imageOrientation = getImageOrientation image

  sizeAndPositionUploadedCustomImage image

getImageOrientation = (image) ->
  if image.height() == image.width()
    'square'
  else if image.height() > image.width()
    if revert
      'horizontal'
    else
      'vertical'
  else
    if revert
      'vertical'
    else
      'horizontal'


sizeAndPositionUploadedCustomImage = (image) ->
  if imageOrientation == 'horizontal'
    if revert
      setVerticalImage image
    else
      setHorizontalImage image
  else
    if revert
      setHorizontalImage image
    else
      setVerticalImage image


setVerticalImage = (image) ->
  image.width img_wrapper.width()
  value = (image.height() - image.parent().height())/2

  image.css
    'height': 'auto'
    'width' : '100%'
    'top' : "-#{value}px"

setHorizontalImage = (image) ->
  image.height img_wrapper.height()
  value = (image.width() - image.parent().width()) / 2

  image.css
    'width': 'auto'
    'height': '100%'
    'left' : "-#{value}px"
