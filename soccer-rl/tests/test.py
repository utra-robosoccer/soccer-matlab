import unittest

class TestFactorial(unittest.TestCase):
    """
    Our basic test class
    """

    def test(self):
        """
        The actual test.
        Any method which starts with ``test_`` will considered as a test case.
        """
        self.assertEqual(1, 1)


if __name__ == '__main__':
    unittest.main()
