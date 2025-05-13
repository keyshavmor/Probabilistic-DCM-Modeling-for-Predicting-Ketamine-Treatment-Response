from pathlib import Path
import gzip, shutil

def unzip_nii_gz(root: str | Path, remove_original: bool = False) -> None:
    """
    Recursively gun-zip all *.nii.gz files under *root*.

    Parameters
    ----------
    root : str or pathlib.Path
        Path to the dataset root (e.g. "/Volumes/我的秘密/.../ds005917-download").
    remove_original : bool, default False
        If True, delete each .nii.gz after successful extraction.
    """
    root = Path(root).expanduser().resolve()

    for gz_file in root.rglob("*.tsv.gz"):
        # Turn ".../bold.nii.gz" into ".../bold.nii"
        nii_file = gz_file.with_suffix("")  # strips only ".gz"

        if nii_file.exists():
            print(f"⚠️  Skipping {nii_file} (already exists)")
            continue

        print(f"🗜️  Extracting {gz_file.relative_to(root)} → {nii_file.relative_to(root)}")
        with gzip.open(gz_file, "rb") as src, open(nii_file, "wb") as dst:
            shutil.copyfileobj(src, dst)

        if remove_original:
            gz_file.unlink()
            print(f"🗑️  Deleted {gz_file.name}")

    print("✅ Done.")


unzip_nii_gz(
    "/Volumes/我的秘密/Main/Translational_Neuromodeling/Project/ds005917-download",
    remove_original=True   # set to True if you want the .gz files removed afterwards
)