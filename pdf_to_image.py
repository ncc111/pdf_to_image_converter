"""
PDF to Image Converter (GUI)

Converts every page of a PDF into a separate JPG or PNG file.
Output naming: <input_file>_page<N>.<jpg|png>

Requirements:
    pip install pymupdf
"""

import os
import threading
import tkinter as tk
from tkinter import filedialog, messagebox, ttk

import pymupdf  # PyMuPDF


def convert_pdf_to_images(pdf_path, output_dir, image_format="png", dpi=200,
                          progress_callback=None):
    """Convert each page of pdf_path into an image file in output_dir.

    Returns a list of created file paths.
    """
    image_format = image_format.lower()
    if image_format not in ("png", "jpg"):
        raise ValueError("image_format must be 'png' or 'jpg'")

    base_name = os.path.splitext(os.path.basename(pdf_path))[0]
    os.makedirs(output_dir, exist_ok=True)

    zoom = dpi / 72.0  # PDF base resolution is 72 DPI
    matrix = pymupdf.Matrix(zoom, zoom)
    created = []

    with pymupdf.open(pdf_path) as doc:
        total = doc.page_count
        for index, page in enumerate(doc, start=1):
            # JPG has no alpha channel, so always render without alpha
            pix = page.get_pixmap(matrix=matrix, alpha=False)
            out_path = os.path.join(
                output_dir, f"{base_name}_page{index}.{image_format}")
            if image_format == "jpg":
                pix.save(out_path, jpg_quality=95)
            else:
                pix.save(out_path)
            created.append(out_path)
            if progress_callback:
                progress_callback(index, total)

    return created


class PdfToImageApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("PDF to Image Converter")
        self.geometry("560x300")
        self.resizable(False, False)

        self.pdf_path = tk.StringVar()
        self.output_dir = tk.StringVar()
        self.image_format = tk.StringVar(value="png")
        self.dpi = tk.IntVar(value=200)
        self.status = tk.StringVar(value="Select a PDF file to begin.")

        self._build_ui()

    # ---------- UI ----------
    def _build_ui(self):
        pad = {"padx": 8, "pady": 6}
        frame = ttk.Frame(self, padding=12)
        frame.pack(fill="both", expand=True)

        ttk.Label(frame, text="PDF file:").grid(row=0, column=0, sticky="w", **pad)
        ttk.Entry(frame, textvariable=self.pdf_path, width=50).grid(row=0, column=1, **pad)
        ttk.Button(frame, text="Browse...", command=self._browse_pdf).grid(row=0, column=2, **pad)

        ttk.Label(frame, text="Output folder:").grid(row=1, column=0, sticky="w", **pad)
        ttk.Entry(frame, textvariable=self.output_dir, width=50).grid(row=1, column=1, **pad)
        ttk.Button(frame, text="Browse...", command=self._browse_output).grid(row=1, column=2, **pad)

        ttk.Label(frame, text="Format:").grid(row=2, column=0, sticky="w", **pad)
        fmt_frame = ttk.Frame(frame)
        fmt_frame.grid(row=2, column=1, sticky="w", **pad)
        ttk.Radiobutton(fmt_frame, text="PNG", value="png",
                        variable=self.image_format).pack(side="left", padx=(0, 15))
        ttk.Radiobutton(fmt_frame, text="JPG", value="jpg",
                        variable=self.image_format).pack(side="left")

        ttk.Label(frame, text="Resolution (DPI):").grid(row=3, column=0, sticky="w", **pad)
        ttk.Combobox(frame, textvariable=self.dpi, width=10, state="readonly",
                     values=[72, 100, 150, 200, 300, 600]).grid(row=3, column=1, sticky="w", **pad)

        self.convert_btn = ttk.Button(frame, text="Convert", command=self._start_conversion)
        self.convert_btn.grid(row=4, column=1, sticky="w", **pad)

        self.progress = ttk.Progressbar(frame, length=420, mode="determinate")
        self.progress.grid(row=5, column=0, columnspan=3, **pad)

        ttk.Label(frame, textvariable=self.status, foreground="#333").grid(
            row=6, column=0, columnspan=3, sticky="w", **pad)

    # ---------- Handlers ----------
    def _browse_pdf(self):
        path = filedialog.askopenfilename(
            title="Select PDF file",
            filetypes=[("PDF files", "*.pdf"), ("All files", "*.*")])
        if path:
            self.pdf_path.set(path)
            # Default output folder = folder of the PDF
            if not self.output_dir.get():
                self.output_dir.set(os.path.dirname(path))

    def _browse_output(self):
        path = filedialog.askdirectory(title="Select output folder")
        if path:
            self.output_dir.set(path)

    def _start_conversion(self):
        pdf = self.pdf_path.get().strip()
        out_dir = self.output_dir.get().strip() or os.path.dirname(pdf)

        if not pdf or not os.path.isfile(pdf):
            messagebox.showerror("Error", "Please select a valid PDF file.")
            return

        self.convert_btn.config(state="disabled")
        self.progress["value"] = 0
        self.status.set("Converting...")

        threading.Thread(
            target=self._run_conversion,
            args=(pdf, out_dir, self.image_format.get(), int(self.dpi.get())),
            daemon=True,
        ).start()

    def _run_conversion(self, pdf, out_dir, fmt, dpi):
        try:
            files = convert_pdf_to_images(
                pdf, out_dir, fmt, dpi,
                progress_callback=lambda i, n: self.after(0, self._update_progress, i, n))
            self.after(0, self._on_done, files, out_dir)
        except Exception as exc:  # show any error in the UI
            self.after(0, self._on_error, exc)

    def _update_progress(self, current, total):
        self.progress["maximum"] = total
        self.progress["value"] = current
        self.status.set(f"Converting page {current} of {total}...")

    def _on_done(self, files, out_dir):
        self.convert_btn.config(state="normal")
        self.status.set(f"Done! {len(files)} image(s) saved to: {out_dir}")
        messagebox.showinfo("Success", f"Created {len(files)} image file(s) in:\n{out_dir}")

    def _on_error(self, exc):
        self.convert_btn.config(state="normal")
        self.status.set("Conversion failed.")
        messagebox.showerror("Error", f"Conversion failed:\n{exc}")


if __name__ == "__main__":
    PdfToImageApp().mainloop()
