$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.action == 'show') {
            $('.main__container').fadeIn()
            $('.main__bottom-container').hide()
            //$('.main__death-description').text('Du wirst in 25 Minuten automatisch wiederbelebt')
        } else if (event.data.action == 'hide') {
            $('.main__container').fadeOut()
            $('.main__bottom-container').hide()
        } else if (event.data.action == 'bottomShow') {
            $('.main__bottom-container').show()
        } else if (event.data.action == 'bottomHide') {
            $('.main__bottom-container').hide()
        } else if (event.data.action == 'timer') {
            $('.time__container').text(event.data.minutes + ':' + event.data.seconds)
            /$('.main__death-description').text(`Du wirst in ${event.data.minutes == 0 ? event.data.seconds + ' Sekunden' : event.data.minutes + ' Minuten'} automatisch wiederbelebt`)
        } else if (event.data.action == 'textEa') {
            //$('.main__death-description').text('Du wirst in 5 Minuten automatisch wiederbelebt')
        } else if (event.data.action == 'syncshit') {
            $('.main__bottom-container1').show()
        } else if (event.data.action == 'pressedsync') {
            $('.main__bottom-container1').hide()
        } else if (event.data.action == 'medicshit') {
            $('.main__bottom-container2').show()
            $('.main__medic-description').show()
        } else if (event.data.action == 'pressedmedic') {
            $('.main__bottom-container2').hide() 
            $('.main__medic-description').hide()
        } else if (event.data.action == 'kampf') {
            if (event.data.kampf) {
                $('.main__container2').fadeIn()
            } else {
                $('.main__container2').fadeOut()
            }
        } else if (event.data.action == 'updateTime') {
            $('#time').text(event.data.time)
        }
    })
})