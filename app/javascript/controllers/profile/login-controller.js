import {Controller} from 'stimulus';
import {feedBackError} from '../../utils/feedback';
import {scanImageForQrCode} from '../../utils/scan-image-for-qr-code';

export default class extends Controller {
  static targets = ['submit', 'inputPassword', 'inputFile', 'form'];

  connect() {
    this.watchForRecaptcha();
  }

  watchForRecaptcha() {
    document.addEventListener('hcaptcha-response', () => {
      this.submitTarget.disabled = false;
    });
  }

  submit(e) {
    if (this.inputPasswordTarget.value.length > 0) return;
    e.preventDefault();
    e.stopPropagation();
    this.inputFileTarget.click();
  }

  async fileSelected(e) {
    const {target} = e;
    const file = target.files[0];
    if (!file) return;

    try {
      this.inputPasswordTarget.value = await scanImageForQrCode(file);
      this.formTarget.submit();
    } catch {
      feedBackError('Invalid qr code');
    }
  }
}
