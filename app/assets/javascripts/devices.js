(function($) {
    function previewImgElement() {
        return $("#device_image_preview img");
    }

    function imageUrlField() {
        return $("#device_image");
    }

    function setImagePreview(url) {
        previewImgElement().attr("src", url);
    }

    $(function() {
        var defaultImage = previewImgElement().attr("src");

        previewImgElement().error(function() {
            setImagePreview(defaultImage);
        });

        imageUrlField().keyup(function() {
            setImagePreview(imageUrlField().val());
        });

        $("#device_image_preview").show();
    });
})(jQuery);